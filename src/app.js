/* global instantsearch algoliasearch */

const search = instantsearch({
  indexName: 'prod_Booklist',
  searchClient: algoliasearch('958JH2XUYH', '3566d6f58734e0b0ff38a49d73486daa'),
});

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: '#searchbox',
  }),
  instantsearch.widgets.clearRefinements({
    container: '#clear-refinements',
  }),
  instantsearch.widgets.refinementList({
    container: '#refinement-list',
    attribute: 'category',
  }),
  instantsearch.widgets.hits({
    container: '#hits',
    templates: {
      item: `
        <div>
          <!-- <img src="{{image}}" align="left" width="50" alt="{{name}}" /> -->
          <div class="hit-name">
            <a href="{{link}}">{{#helpers.highlight}}{ "attribute": "title" }{{/helpers.highlight}}</a>
          </div>
          <div class="hit-description">
            {{#helpers.highlight}}{ "attribute": "category" }{{/helpers.highlight}}
          </div>
      `,
    },
  }),
  instantsearch.widgets.pagination({
    container: '#pagination',
  }),
]);

search.start();
