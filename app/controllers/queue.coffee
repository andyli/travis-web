`import Ember from 'ember'`

Controller = Ember.ArrayController.extend
  isLoaded: false
  content: (->
    result = @store.filter('job', {}, (job) ->
      ['created', 'queued'].indexOf(job.get('state')) != -1
    )
    result.then =>
      @set('isLoaded', true)
    result
  ).property()

`export default Controller`
