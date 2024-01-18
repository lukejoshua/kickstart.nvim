
return {
  s('@if', {
    t '@if (',
    i(1, 'condition'),
    t ') {'
    i(2, 'body'),
    t {'', ''},
    c(3, {
      t '}',
      {
        'else {', 
        i(1),
        '}'
      }
    }),
    i(0),
  }),
}, {
  -- auto snippets
}
