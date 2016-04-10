module.exports =
class SpellhintView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('spellhint')
    @messageContainer = document.createElement('div')
    @messageContainer.classList.add('msg-container')
    @exButton = document.createElement('button')
    @exButton.id = 'foo'
    @exButton.innerHTML = 'XXX'
    @element.appendChild(@exButton)
    @element.appendChild(@messageContainer)
    @handleEvents()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setTypos: (matchObj) ->
    @messageContainer.innerHTML = ""
    @addMessage match for match in matchObj

  addMessage: (match) ->
    # Create message element
    message = document.createElement('div')
    # console.log(match)
    message.textContent = "There is a typo '#{match.matchText}' in #{match.filename} on line #{match.lineno}"
    message.classList.add('message')
    @messageContainer.appendChild(message)

  handleEvents: ->
    @exButton.addEventListener 'click', @closeMe

  closeMe: =>
    console.log('OMG')
