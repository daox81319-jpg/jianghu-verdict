# 江湖裁决 V1

## Product Contract

- Platform: macOS local release candidate, Steam-ready desktop architecture.
- Runtime: Godot 4.7.2.
- Content: four complete cases, three factions, one final judgment and three endings.
- Playtime: 60-90 minutes.
- Required input: mouse or controller. Keyboard shortcuts are optional.
- Core rule: select evidence, select the contradictory statement, then issue a verdict.
- A player must complete the tutorial case without external explanation.

## Visual Thesis

A rain-dark tribunal built from black lacquer, wet stone, aged bronze and paper.
The hall is the visual anchor. Parchment carries facts; vermilion appears only
for contradictions and final seals.

## Content Plan

1. Title: live 3D hall with the game's name and one primary action.
2. Case brief: parties, accusation and three known facts.
3. Hearing: NPC performance in the hall, claim strips and evidence tray.
4. Verdict: three explicit choices and visible short-term consequences.
5. Echo: reputation changes, unlocked evidence and the next case.
6. Ending: one of three outcomes derived from recorded verdicts.

## Interaction Thesis

- Evidence sheets slide onto the desk and rise when selected.
- A valid contradiction fractures the target claim and leaves a vermilion seal.
- The final verdict is committed by a physical seal press and short camera push.

## AI Boundary

Case truth, evidence validity, contradiction edges, unlocks and consequences are
deterministic data. The performance engine may vary wording only after selecting
an allowed speech act. Every generated line must reference known `fact_id`
values. Invalid or delayed output falls back to authored lines.

## V1 Cases

1. Rain Ledger: establish the interaction in one contradiction.
2. Bitter Antidote: resolve a timeline with two contradictions.
3. Silent Witness: separate emotional pressure from factual guilt.
4. The Empty Seat: combine evidence from the first three cases and judge the
   institution rather than one person.

## Release Gates

- All case files pass schema and graph validation.
- No critical line can introduce an unknown fact.
- Every case is completable with suggested actions and without typing.
- Save/load reproduces unlocked evidence, verdicts and reputation.
- Automated campaign replay reaches all endings.
- Release app launches outside the editor and passes signature verification.
