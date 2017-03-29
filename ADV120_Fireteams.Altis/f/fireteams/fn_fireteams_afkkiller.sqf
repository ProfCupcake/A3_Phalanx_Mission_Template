private ["_killTime", "_warned", "_oldDir", "_oldPos", "_nextTime"];

waitUntil {!(isNil "isPlaying")};
while {true} do
{
	waitUntil {isPlaying};
	_killTime = time + AFKKillTime;
	_warned = false;
	_nextTime = time + 1;
	while {isPlaying} do
	{
		_oldDir = getDir player;
		_oldPos = getPos player;
		waitUntil {time > _nextTime};
		_nextTime = _nextTime + 1;
		if
		(
			(_oldDir != getDir player)
			||
			((_oldPos select 0) != ((getPos player) select 0))
			||
			((_oldPos select 1) != ((getPos player) select 1))
			||
			((_oldPos select 2) != ((getPos player) select 2))
			||
			(!(isNull (getConnectedUav player)))
		) then
		{
			_killTime = time + AFKKillTime - 1;
			if (_warned) then
			{
				_warned = false;
				titleText ["You will be killed for AFKing soon", "PLAIN"];
				titleFadeOut 3;
			};
		}
		else
		{
			if (time > _killTime) then
			{
				[] spawn {hintC ("You were killed for being AFK too long");};
				player setDamage 1;
				isPlaying = false;
			}
			else
			{
				if ((!_warned) && (time > (_killTime - 10))) then
				{
					_warned = true;
					titleText [format ["Warning: You are going to be killed for AFKing", 10], "PLAIN"];
					titleFadeOut 5;
				};
			};
		};
	};
	waitUntil {time > _nextTime};
	_nextTime = _nextTime + 1;
};
