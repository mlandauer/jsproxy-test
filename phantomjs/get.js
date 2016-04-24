// This script needs to be run using phantomjs
//
// Example usage:
// ~/.phantomjs/2.1.1/darwin/bin/phantomjs phantomjs/get.js http://localhost:4567/example_dynamic_page

var page = require('webpage').create();
var system = require('system');

if (system.args.length === 1) {
  console.log('Usage: get.js <some URL>');
  phantom.exit();
}

var url = system.args[1];

// This displays console messages from inside the page.evaluate block
page.onConsoleMessage = function(msg) {
  console.log('console:', msg);
};

page.open(url, function (status) {
  var html = page.evaluate(function() {
    // Magically this bit will get evaluated in the context of the page
    return document.documentElement.innerHTML;
  });

  console.log(html);

  phantom.exit();
});
