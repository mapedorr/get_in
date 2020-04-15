extends Node
# Crea eventos de uso global para que cualquiera pueda emitir y conectarse a
# estas señales
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ World ░░░░░░░░
signal socket_rotated(socket)
signal plug_moved(row, col)
signal plug_excited(link)
signal level_won
signal level_lost
signal last_move_alerted
signal level_finished
signal level_restarted
signal level_started
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Audio ░░░░░░░░
signal play_requested(source, sound)
signal stop_requested(source, sound)
signal pause_requested(source, sound)
signal stream_finished(source, sound)
