extends Node


signal NPCDialogueTrigger(npc_texture: Texture2D, dialogue_lines: Array)
# EMIT LIKE THIS: SignalBus.enemy_died.emit(something, something_else)
""" LISTEN LIKE THIS
func _ready():
	SignalBus.enemy_died.connect(_on_enemy_died)

func _on_enemy_died(param, another_param):
"""

signal dialogue_started(dialogue_lines: Array)
signal dialogue_finished

signal SetJarCount(count: int)
signal JarCountIncrement

signal PlayerStepsSound
signal PlayerJumpAudio
signal PlayerLandedAudio
signal PaperStarCollectAudio
signal WoodHitAudio
signal TextAudio
signal InteractAudio
signal WoodBlockPushAudio
signal PuzzleComplete
signal PageTurnAudio
signal MusicAudio
