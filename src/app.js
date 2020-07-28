/* global instantsearch algoliasearch */

const search = instantsearch({
  indexName: 'prod_Booklist',
  searchClient: algoliasearch('958JH2XUYH', '3566d6f58734e0b0ff38a49d73486daa'),
});

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: '#searchbox',
    placeholder: 'Search for Big5 booklists',
    autofocus: true,
    searchAsYouType: true,
    showLoadingIndicator: true,
  }),
  instantsearch.widgets.clearRefinements({
    container: '#clear-refinements',
    operator: 'or',
    searchablePlaceholder: 'Search for Big5 booklists',
  }),
  instantsearch.widgets.refinementList({
    container: '#brand-list',
    attribute: 'category',
  }),
  instantsearch.widgets.hits({
    container: '#hits',
    templates: {
      item: `
        <div>
          <div class="hit-name">
            {{#helpers.highlight}}{ "attribute": "title" }{{/helpers.highlight}}
          </div>
          <div class="hit-description">
            {{#helpers.highlight}}{ "attribute": "category" }{{/helpers.highlight}}
          </div>
        </div>
      `,
    },
  }),
  instantsearch.widgets.pagination({
    container: '#pagination',
  }),
]);

search.start();
