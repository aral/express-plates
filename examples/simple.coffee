express = require 'express'
app = express()
plates = require('express-plates').init(app)

# app.set 'view engine', 'html'
app.set 'views', __dirname + '/views'

app.get '/', (req, res) ->
    map = plates.Map()

    # These tests have been adapted from the use cases documented at
    # https://github.com/flatiron/plates
    #
    # NB. If you change the HTML template, you have to restart node (even with nodemon)
    #

    map.class('a-different-class').to('content')
    map.where('id').is('title').to('title')
    map.where('data-content').is('name').to('name')

    # Replace an attribute if it is a match
    map.where('href').is('/').insert('newURL')

    # Partial value replacement
    map.where('href').has(/scribbles/).insert('correctURLFragment')

    # Arbitrary attribute
    map.where('data-name').is('stripes').use('stipesImageURL').as('src')

    # Collections
    # (With reference to https://github.com/flatiron/plates/issues/93)
    map.class('friends').use('friends')
    map.class('name').use('name')
    map.class('skills').use('skills')

    # Contrived example of conditionally removing a node
    friends = yes
    if friends
        map.class('no-friends-warning').remove()
    else
        map.class('friends-list').remove()

    res.render 'simple',
        data:
            title: 'Plates is pretty cool, so is Express'
            name: 'Express-Plate user'
            content: 'It seems to work quiet well'
            newURL: 'http://aralbalkan.com'
            correctURLFragment: 'notes'
            stipesImageURL: 'http://aralbalkan.com/scribbles/vector-diagonal-stripe-patterns/stripes-for-post.svg'
            friends: [
                    {name: 'Laura', skills: 'design, development, illustration, speaking'},
                    {name: 'Seb', skills: 'particles, games, JavaScript, C++'},
                    {name: 'Natalie', skills: 'HTML, CSS'}
            ]

        map: map

    return

app.listen(3000);