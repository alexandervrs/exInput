///scr_ease_slowmo(time, start, change, duration)

/**
 * Returns the easing function result
 *
 * @param   time      Time current position, real
 * @param   start     Start time position, real
 * @param   change    Change current amount, real
 * @param   duration  Total duration, real
 * 
 * @return  Returns the easing function result, real
 */

var _t = argument[0];
var _b = argument[1];
var _c = argument[2];
var _d = argument[3];

var _change = 1-(_d - _t)/_d;
_t = _change;

var _linear_ratio = 0.5;
var _power        = 0.4;

if (argument_count >= 5) {
    _linear_ratio = 0.5
}

if (_linear_ratio > 1) {
    _linear_ratio = 1;
}

var _p = _power;

if (_linear_ratio == 1) {
    _p = 0;
}

_p1 = (1 - _linear_ratio) / 2;
_p2 = _linear_ratio;
_p3 = _p1 + _p2;

_r = _t + (0.5 - _t) * _p;

if (_t < _p1) {
    _t = 1 - (_t / _p1);
    return _r - (_t * _t * _t * _t * _r);
} else if (_t > _p3) {
    _t = (_t - _p3) / _p1;
    return _r + ((_t - _r) * _t * _t * _t * _t);
}

return _r;
