`import Ember from 'ember'`
`import LimitedArray from 'travis/utils/limited-array'`
`import Broadcast from 'travis/models/broadcast'`

Controller = Ember.ArrayController.extend
  needs: ['currentUser']
  currentUserBinding: 'controllers.currentUser'

  init: ->
    @_super.apply this, arguments
    @set('flashes', LimitedArray.create(limit: 1, content: []))

  model: (->
    broadcasts = @get('unseenBroadcasts')
    flashes = @get('flashes')
    model = []
    model = model.concat(broadcasts.toArray()) if broadcasts
    model = model.concat(flashes.toArray().reverse())    if flashes
    model.uniq()
  ).property('unseenBroadcasts.length', 'flashes.length')

  unseenBroadcasts: (->
    @get('broadcasts').filterProperty('isSeen', false)
  ).property('broadcasts.isLoaded', 'broadcasts.length')

  broadcasts: (->
    if @get('currentUser.id') then @store.find('broadcast') else Ember.A()
  ).property('currentUser.id')

  loadFlashes: (msgs) ->
    for msg in msgs
      type = Ember.keys(msg)[0]
      msg = { type: type, message: msg[type] }
      @get('flashes').unshiftObject(msg)
      Ember.run.later(this, (-> @get('flashes.content').removeObject(msg)), 15000)

  close: (msg) ->
    if msg instanceof Broadcast
      msg.setSeen()
      @notifyPropertyChange('unseenBroadcasts')
    else
      @get('flashes').removeObject(msg)

  actions:
    close: (msg) ->
      @close(msg)

`export default Controller`
