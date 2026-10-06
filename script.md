0:00-0:30 : Intro - Maria
For this BakeOff, our goal was to redesign a 4-by-4 button grid to help users select targets as quickly and accurately as possible. Our team focused on reducing the time and effort required to move the cursor to the target once the user already knows where it is. The team also ensured that every square must remain equally clickable at all times. Our process consisted of two rounds of prototyping, testing, and refinement before arriving at our final design.

0:30-1:15 : Prototype 1 - Maria
Our first prototype explored interaction using both the keyboard and trackpad.
The target square was highlighted in a bright green-yellow color to make its location immediately visible to the user. We also added an outline around the square currently selected by the cursor to make it easier to spot what square was currently selected. Instead of relying entirely on trackpad movement, users could use the arrow keys to move between squares and then use the trackpad to select a square. Our hypothesis was that these keyboard movements could reduce the amount of precise cursor movement required, particularly when moving between buttons that were farther apart.

1:15–2:00 : Prototype 2 - Maria
Our second prototype focused more on the visual guidance aspect of the design. We added directional arrows that pointed toward the current target square, while still keeping the previous design, an outline to indicate the user's current position. With this prototype, the goal was to reduce the cognitive effort required to determine the direction of movement. Unlike the first prototype, this design focused on helping users make faster trackpad movements rather than replacing some of that movement with keyboard input.

2:00–2:45 — Prototype 3: One-Step Lookahead - Maria
Our third prototype took advantage of the assignment's one-step lookahead rule. The current target remained clearly highlighted, but we also displayed the next target using a different color. The next target was not easier to click and remained exactly the same size and clickability as every other square, preserving the golden rule. The lookahead allowed users to begin mentally planning their next movement before completing the current one. Our hypothesis was that this would reduce the transition time between consecutive selections.

2:45–3:45 — First-Round Testing and Refinement - Ishaan
*Visual: Show video clips of team members testing each prototype alongside completion time graphs.
After reviewing all three concepts, we conducted our first round of testing. Each participant received a practice run before completing the timed trials, and we evaluated the prototypes primarily based on completion time, while also monitoring accuracy because scores below 95 percent receive a penalty. During testing, we compared which features actually reduced pointing time and which introduced additional cognitive or physical effort.

We found that Prototype 3 performed best, averaging around 0.95 seconds per target, because the one-step lookahead allowed users to visually locate their next move before completing the current click, essentially eliminating visual search latency between targets. Prototype 2 averaged around 1.20 seconds, while Prototype 1 was the slowest at roughly 1.95 seconds.

We also noticed that the arrow key navigation in Prototype 1 created significant difficulty because discrete stepping across a 4-by-4 grid required multiple keystrokes per target, adding substantial motor overhead compared to a fluid trackpad swipe. In Prototype 2, drawing individual arrows on all fifteen inactive buttons created unnecessary visual clutter without providing much extra value, since users naturally locked onto the bright green target anyway. Furthermore, across all three prototypes, physical trackpad clicking remained a major bottleneck—pressing down caused slight finger tremor, leading to occasional misses near the button boundaries.

Based on these results, we decided to keep the one-step lookahead and the hover outline feedback, remove the arrow key navigation and individual button arrows, and explore replacing the physical trackpad click with a keyboard trigger.

3:45–4:45 — Second-Round Prototype - Ishaan
For our second iteration, we combined the strongest elements from our initial prototypes and explored a two-handed bimanual interaction technique: using the space bar alongside the trackpad.

The trackpad still played the essential role in continuous pointing, while the keyboard provided an additional way to streamline the interaction. Based on our first-round results, we dropped the discrete arrow key navigation and the cluttered directional arrows entirely, retaining the clean one-step lookahead—where the active target is bright green and the upcoming target is yellow with a "NEXT" label—along with the high-contrast hover outline. 

Decoupling steering from actuation completely eliminated trackpad downstroke latency and cursor slip. During second-round testing, this bimanual technique produced a dramatic improvement, dropping our average selection time down to approximately 0.62 seconds per button while maintaining 100 percent accuracy.

4:45–5:30 — Refinement and Final Prototype - Ishaan
After testing the second-round prototype, we made our final refinements. While the space bar solved mechanical click latency, we noticed users still spent time verifying alignment before pressing space and mentally calculating the flick angle between consecutive targets.

To address this, our final design incorporates:
First, a clean directional trajectory line drawn directly from the current target to the next target, visually encoding the exact angle and distance of the upcoming ballistic flick.
Second, subtle full-screen orthogonal laser crosshairs through the target center, allowing users to align horizontal and vertical axes using peripheral vision.
Third, an enhanced precision reticle cursor that dynamically lights up green whenever hovering over any of the sixteen buttons, providing instant peripheral confirmation that the cursor is in-bounds and ready to click.
Finally, an immediate auditory beep on hit to provide closed-loop sensory feedback.

We selected these features because they maximize speed and cognitive feedforward without adding visual clutter. We also ensured the design strictly satisfies all bakeoff guidelines: every square remains equally clickable at all times, button hitboxes and padding are completely unchanged, and lookahead only provides visual feedforward without prioritizing target activation.

5:30–6:00 — Final Testing and Conclusion - Ishaan
Finally, we benchmarked our refined final prototype against the scaffold baseline and our early prototypes. The scaffold baseline averaged approximately 1.45 seconds per button. Our final prototype achieved an average completion time of approximately 0.42 seconds per button with 100 percent accuracy—more than three times faster with zero penalty. 

Overall, our design process showed us that improving a pointing task isn't about artificially enlarging hitboxes or altering the layout. Instead, pairing visual feedforward with two-handed bimanual input eliminates both visual search latency and mechanical click tremor. Through two rounds of prototyping, testing, and refinement, we arrived at a design that lets users continuously steer with one hand while effortlessly firing with the other, making target acquisition as fast and accurate as possible.
