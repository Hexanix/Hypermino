Hypermino ver. 0.2.2:

 - Block now has a speedModifer property. Applied to multimino speed. (Not really used)
 - Collision tweak: Outside block collisions don't stop the entirety of the multimino. Instead, ther rest fall down on.
   A side-effect is that outside collision now has a cascading effect when deleting blocks. I've kept this to keep code simple and not as busy.
 
 To fix:
 - Possibly make multiminos that complete a line with a part outside delete the necessary blocks BUT NOT the ones outside.
   (Will have to somehow make it check for collision on every block.type switch on resting.)