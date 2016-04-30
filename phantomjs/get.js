// This script needs to be run using phantomjs
//
// Example usage:
// ~/.phantomjs/2.1.1/darwin/bin/phantomjs phantomjs/get.js https://www.google.com.au/

var page = require('webpage').create();
var system = require('system');

function doRender() {
  var html = page.evaluate(function() {
    // Magically this bit will get evaluated in the context of the page
    // TODO Also return doctype. This currently doesn't
    return document.documentElement.outerHTML;
  });
  // Put in some arbitrary text string that signals the start
  // of the html
  console.log("**jksdhljasdhjwb**")
  console.log(html);

  phantom.exit();
}

if (system.args.length === 1) {
  console.log('Usage: get.js <some URL>');
  phantom.exit();
}

var url = system.args[1];
var count = 0;
var renderTimeout;

// This displays console messages from inside the page.evaluate block
page.onConsoleMessage = function(msg) {
  // For the time being disable console output here.
  // TODO Return console output by making this script return json
  // which contains the html and the console output separately
  //console.log('console:', msg);
};

page.onResourceRequested = function(request) {
  count += 1;
  clearTimeout(renderTimeout);
};

page.onResourceReceived = function(response) {
  if (response.stage == 'end') {
    count -= 1;
    if (count == 0) {
      renderTimeout = setTimeout(doRender, 300);
    }
  }
};

page.open(url, function (status) {
  // This is the fallback in case something doesn't work with the network monitoring
  setTimeout(doRender, 10000);
});
