module.exports =
class SpellhintView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('spellhint')
    console.log "Constructing"

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setCount: (linenos) ->
    while @element.firstChild
      @element.removeChild(@element.firstChild)
    @addMessage lineno for lineno in linenos

  addMessage: (lineno) ->
    # Create message element
    message = document.createElement('div')
    message.textContent = "There is a typo on line #{lineno}"
    message.classList.add('message')
    @element.appendChild(message)
