Spellhint = require '../lib/spellhint'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Spellhint", ->
  [workspaceElement, editor, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('spellhint')
    waitsForPromise ->
      atom.workspace.open().then (e) ->
        editor = e

  describe "when the spellhint:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.spellhint')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'spellhint:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.spellhint')).toExist()

        spellhintElement = workspaceElement.querySelector('.spellhint')
        expect(spellhintElement).toExist()

        spellhintPanel = atom.workspace.panelForItem(spellhintElement)
        expect(spellhintPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'spellhint:toggle'
        expect(spellhintPanel.isVisible()).toBe false

    it "tests the content of the view", ->
      editor.setText('foo bar magneto')
      atom.commands.dispatch workspaceElement, 'spellhint:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        spellhintText = workspaceElement.querySelector('.message').innerHTML
        expect(spellhintText).toEqual 'There is a typo on line 1'

    it "tests the content of a bigger view", ->
      editor.setText('foo bar \nmagneto')
      atom.commands.dispatch workspaceElement, 'spellhint:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        spellhintText = workspaceElement.querySelector('.message').innerHTML
        expect(spellhintText).toEqual 'There is a typo on line 2'

    it "shows two matches in modal", ->
      editor.setText('foo bar \nmagneto\nblah\nmagneto')
      atom.commands.dispatch workspaceElement, 'spellhint:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        spellhintText = workspaceElement.querySelector('.message').innerHTML
        expect(spellhintText).toEqual 'There is a typo on line 2\nThere is a typo on line 4'

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.spellhint')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'spellhint:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        spellhintElement = workspaceElement.querySelector('.spellhint')
        expect(spellhintElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'spellhint:toggle'
        expect(spellhintElement).not.toBeVisible()
