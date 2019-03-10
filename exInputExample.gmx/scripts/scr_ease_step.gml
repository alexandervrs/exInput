///scr_ease_step(time, start, change, duration, steps)

/**
 * Returns the easing function result
 *
 * @param   time      Time current position, real
 * @param   start     Start time position, real
 * @param   change    Change current amount, real
 * @param   duration  Total duration, real
 * @param   steps     (optional) Number of steps for the snap, real
 * 
 * @return  Returns the easing function result, real
 */

var _t = argument[0];
var _b = argument[1];
var _c = argument[2];
var _d = argument[3];

var _change = 1-(_d - _t)/_d;
var _p = _change;

var _steps = _d/8;

if (argument_count >= 5) {
    _steps = argument[4];
}

var _p1 = 1 / _steps;
var _p2 = _steps + 1;

if (_p < 0) {
    _p = 0;
} else if (_p >= 1) {
    _p = 0.999999999;
}

return ((_p2 * _p) >> 0) * _p1;
