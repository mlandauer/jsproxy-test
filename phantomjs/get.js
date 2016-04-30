// This script needs to be run using phantomjs
//
// Example usage:
// ~/.phantomjs/2.1.1/darwin/bin/phantomjs phantomjs/get.js

var page = require('webpage').create();
var system = require('system');

function doRender(page) {
  var html = page.evaluate(function() {
    // Magically this bit will get evaluated in the context of the page
    return document.documentElement.innerHTML;
  });
  console.log(html);

  phantom.exit();
}

if (system.args.length === 1) {
  console.log('Usage: get.js <some URL>');
  phantom.exit();
}

var url = system.args[1];

// This displays console messages from inside the page.evaluate block
page.onConsoleMessage = function(msg) {
  // For the time being disable console output here.
  // TODO Return console output by making this script return json
  // which contains the html and the console output separately
  //console.log('console:', msg);
};

page.open(url, function (status) {
  // As a first (very rough) pass wait for a
  // half second before rendering the page
  setTimeout(function() {
    doRender(page);
  }, 500);
});
