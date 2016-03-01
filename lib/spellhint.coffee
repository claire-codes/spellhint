SpellhintView = require './spellhint-view'
{CompositeDisposable} = require 'atom'

module.exports = Spellhint =
  spellhintView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @spellhintView = new SpellhintView(state.spellhintViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @spellhintView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'spellhint:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @spellhintView.destroy()

  serialize: ->
    spellhintViewState: @spellhintView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      lineno = 4
      editor = atom.workspace.getActiveTextEditor()
      editor.scan /magneto/i, (o) -> lineno = o.range.end.row + 1
      # lineno = foo[0]
      @spellhintView.setCount(lineno)
      @modalPanel.show()
