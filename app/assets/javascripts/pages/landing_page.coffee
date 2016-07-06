# = require fullpage

$ ->
  return if ( container = $ '[data-aurora-web-module="landing-page"]' ).length is 0

  container.fullpage
    sectionSelector: '.fullpage-section'
    # paddingBottom: '3em'
    # fixedElements: 'body > footer'
