## pipelines.plumbing

Fetch information from the internet, filter it, format it and send it

Available at https://pipelines.plumbing

Contact dorian@dorianmarie.fr

---

Export Twitter items as CSV

```
require "csv"; CSV.open("tmp/twitter-items.csv", "wb") do |csv| csv << Item.twitter.first.e
xtras.keys; Item.twitter.each { |item| csv << item.extras.values } end; p
```
