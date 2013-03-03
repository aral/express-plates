express = require 'express'
app = express()
plates = require('express-plates').init(app)

# app.set 'view engine', 'html'
app.set 'views', __dirname + '/views'

app.get '/', (req, res) ->
    map = plates.Map()

    # Some of these tests have been adapted from the use cases documented at
    # https://github.com/flatiron/plates

    # Tag
    # Note: Bug in plates: If title tag already has text content it is not
    # ===== replaced regardless of whether you use .to(), .insert(), or .use()
    map.tag('title').use('title')

    # By class
    map.class('target').to('content')

    # By ID
    map.where('id').is('title').to('title')

    # By attribute selector
    map.where('data-content').is('name').to('name')

    # Replace an attribute if it is a match
    map.where('href').is('/').insert('newURL')

    # Partial value replacement
    map.where('href').has(/aralbalkan/).insert('correctURLFragment')

    # Arbitrary attributes
    map.where('data-content').is('photo').use('aralImageURL').as('src')

    #
    # Collections
    #
    # (With reference to https://github.com/flatiron/plates/issues/93)
    #
    # Note: it seems that the class name must match the data name exactly
    # ===== for this collection feature to work. This feels like a big limitation.
    #       (And if they must match, why not infer it from the data?)
    #
    map.class('friend').use('friend')
    map.class('name').use('name')
    map.class('skills').use('skills')

    # Conditionals (contrived example of conditionally removing a node)
    # Set friends = no to test.
    friends = yes
    if friends
        map.class('no-friends-warning').remove()
    else
        map.class('friends-list').remove()

    res.render 'simple',
        data:
            title: 'Express 3‐Plates sample'
            name: 'Express 3‐Plates'
            content: 'This is a simple example to demonstrate Express 3‐Plates.'
            newURL: 'http://aralbalkan.com'
            correctURLFragment: 'moderniosdevelopment'
            aralImageURL: 'http://aralbalkan.com/images/aral.jpg'
            friend:
                [
                    {name: 'Laura', skills: 'design, development, illustration, speaking'},
                    {name: 'Seb', skills: 'particles, games, JavaScript, C++'},
                    {name: 'Natalie', skills: 'HTML, CSS'}
                ]

        map: map

app.listen(3000);