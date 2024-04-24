# Migrating from Legacy using Strangler Fig

We are using the [Strangler Fig Pattern](https://martinfowler.com/bliki/StranglerFigApplication.html) in order to move from the legacy components of Opal to new components and a new architecture in an incremental way.

This approach provides an alternative to building a completely new system from scratch and doing a switch over once it is fully completed. Instead, the new system is built and operated in parallel and new functionality is only added to the new system. The new system is incrementally built and the old system eventually strangled.

We will do this in incremental stages, beginning with the backend. The listener will serve as an event interceptor to “intercept” the events coming from the app and redirect them to the new API instead.

Eventually, when we build a new app, it might directly communicate with the API. That way, we would slowly strangulate the listener as well (details TBD).

## Resources

* [Strangler Fig Application - Martin Fowler](https://martinfowler.com/bliki/StranglerFigApplication.html)
* How Shopify applied the Strangler Fig Pattern within the same codebase: [Refactoring Legacy Code with the Strangler Fig Pattern](https://shopify.engineering/refactoring-legacy-code-strangler-fig-pattern)

### Additional articles about Strangler Fig Pattern

* Paper: [An Agile Approach to a Legacy System](http://cdn.pols.co.uk/papers/agile-approach-to-legacy-systems.pdf)
* [Legacy Application Strangulation : Case Studies](https://paulhammant.com/2013/07/14/legacy-application-strangulation-case-studies/)
* [The Strangler Fig Migration Pattern | by Diana Darie | Medium](https://dianadarie.medium.com/the-strangler-fig-migration-pattern-2e20a7350511)
* [The Strangler pattern in practice - Michiel Rook's blog](https://www.michielrook.nl/2016/11/strangler-pattern-practice/)
* [What is the Strangler Fig Pattern and How it Helps Manage Legacy Code](https://www.freecodecamp.org/news/what-is-the-strangler-pattern-in-software-development/)
* [The Ship of Theseus to NOT rewrite a legacy system from scratch](https://understandlegacycode.com/blog/ship-of-theseus-avoid-rewrite-legacy-system/)
* [https://docs.microsoft.com/en-us/azure/architecture/patterns/strangler-fig](https://docs.microsoft.com/en-us/azure/architecture/patterns/strangler-fig)
