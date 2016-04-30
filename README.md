# A little experiment in proxying
## And a very small step towards potentially writing a point-and-click web scraper

[Kimono](https://www.kimonolabs.com/) was like a momentary view of the future of scraping

Sure, it could only scrape a subset of "real" websites and the user interface, once
you got beyond the basic functionality, was a little unconventional and non-obvious,
but Kimono really made the simple case of scraping much much easier than before.

But then, Kimono was shut down because the team was acquired by the [secretive](http://www.cnbc.com/2015/12/24/palantir-technologies-silicon-valleys-most-secretive-startup-raises-880-million.html) and
[somewhat shady](http://www.forbes.com/sites/andygreenberg/2013/08/14/agent-of-intelligence-how-a-deviant-philosopher-built-palantir-a-cia-funded-data-mining-juggernaut/2/#7ab791044267) [Palantir](https://www.palantir.com/).

So, what would it take to build something like the Kimono point and click interface and with:

* All functionality to be entirely in the browser
* No requirement for a browser plugin
* A smooth road between "beginner" and "expert"
* By default handle javascript sites without any extra effort on your part

### So what does all this mean technically then?

We need a web page that can embed another page. iframes won't cut it because we need to be able to run javascript that runs across everything. So, we need to literally embed the html from one page into another. We want to embedded html to be rendered using the javascript from the embedded page without interfering with the javascript from the main page. Sounds like a tall order.

So, here's a piece of the puzzle: we write a proxy, that loads an arbitrary web page, runs the javascript of the web page (on the server), renders the html, strips the script tags and returns the html. So, what the proxy returns is static html.

This little project is an experiment in doing that.

### Development

#### Requirements

* Ruby (I'm currently using 2.2.3 but it should work with other versions too)

#### Installing
```bash
bundle install
```

#### Running

```bash
bundle exec rerun ./proxy.rb
```
(This uses the rerun gem to automatically reload the sinatra app if a file changes)


and navigate to http://localhost:4567/example_dynamic_page

Switch off javascript and you'll see the page doesn't fully load.

Then, go to
http://localhost:4567

This page is proxying the 'example_dynamic_page'. You should see the same looking page as before. Now, switch off javascript and the page still works. Magic!


### Copyright & License

Copyright Matthew Landauer. Licensed under the Affero GPL. See LICENSE file for more details.
