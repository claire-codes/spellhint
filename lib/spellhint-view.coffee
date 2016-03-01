module.exports =
class SpellhintView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('spellhint')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The Spellhint package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  addTypoMessagefor: (lineno) ->
     "There is a typo on line #{lineno}"

  setCount: (linenos) ->
    displayText = ""
    displayText += "There is a typo on line #{lineno}\n" for lineno in linenos
    displayText = displayText.replace /\s+$/g, ""
    @element.children[0].textContent = displayText
