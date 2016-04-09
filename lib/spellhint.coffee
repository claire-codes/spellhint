path = require('path')
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
    @subscriptions.add atom.commands.add 'atom-workspace', 'spellhint:close': => @close()

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
      linenos = []
      editor = atom.workspace.getActiveTextEditor()
      allEditors = atom.workspace.getTextEditors()
      for editor in allEditors
        file = editor?.buffer?.file
        if (file == null) then filename = 'untitled' else filename = path.basename(file?.path)
        editor.scan /magneto/ig, (matchObj) ->
          matchObj.lineno = matchObj.range.end.row + 1
          matchObj.filename = filename
          linenos.push(matchObj)
      @spellhintView.setTypos(linenos)
      @modalPanel.show()

  close: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
