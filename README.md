# README

This is a minimal proof of concept demonstrating a working extend visibility timeout setting in Shoryuken for ActiveJob. It all boils down to adding the following magic line somewhere in your Shoryuken configuration code:

```
ActiveJob::QueueAdapters::ShoryukenAdapter::JobWrapper.shoryuken_options(auto_visibility_timeout: true)
```

To see it in action, make sure you have docker installed, and run `bin/run`. See that script for details on how it works.

There are two ways you can invoke this script:
* `bin/run` to see how Shoryuken behaves when the magic line is used
* `DISABLE_AUTO_EXTEND_VISIBILITY_TIMEOUT=1 bin/run` to see how it behaves without the magic line 
