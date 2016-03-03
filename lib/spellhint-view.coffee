module.exports =
class SpellhintView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('spellhint')

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  setTypos: (matchObj) ->
    @element.innerHTML = ""
    @addMessage match for match in matchObj

  addMessage: (match) ->
    # Create message element
    message = document.createElement('div')
    console.log(match)
    message.textContent = "There is a typo '#{match.matchText}' in #{match.filename} on line #{match.lineno}"
    message.classList.add('message')
    @element.appendChild(message)
