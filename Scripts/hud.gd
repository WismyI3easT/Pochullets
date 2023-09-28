extends Control

@onready var roundNumber = $Rounds:
    set(val):
        roundNumber.text = "Round: " + str(val)


