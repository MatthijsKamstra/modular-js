import HxOverrides from './HxOverrides';
import $bind from './bind_stub';
export default function $iterator(o) {
    if( o instanceof Array ) {
        return function() {
            return HxOverrides.iter(o);
        };
    }
    return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator;
}