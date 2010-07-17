SET search_path = public,tap;

BEGIN;
--SELECT plan( 5 );
SELECT * FROM no_plan();

-- Test ins_ignore().
SELECT has_function('ins_ignore');
SELECT has_function('ins_ignore', ARRAY['text', 'text']);
SELECT function_returns('ins_ignore', 'boolean');
SELECT function_lang_is('ins_ignore', 'plpgsql');
SELECT volatility_is('ins_ignore', 'volatile');
SELECT is_definer('ins_ignore');

-- Insert some users.
SELECT ins_user((ARRAY['jrivers', 'drickles', 'mali', 'gmarx'])[i], '*****')
FROM generate_series(1,4) AS i;

SELECT is(
    COUNT(*)::INT, 0,
    'Should start with no ignored'
) FROM ignored;

SELECT ok(
    ins_ignore('jrivers', 'drickles'),
    'Have Joan ignore Don'
);

SELECT is(
    COUNT(*)::INT, 1,
    'Should now have 1 ignored'
) FROM ignored;

SELECT is(
    ignored.*,
    ROW('jrivers', 'drickles')::ignored,
    'Should have the proper ignored record'
) FROM ignored WHERE user_nick = 'jrivers';

SELECT ok(
    NOT ins_ignore('jrivers', 'drickles'),
    'Have Joan ignore Don again'
);

SELECT ok(
    ins_ignore('drickles', 'jrivers'),
    'Have Don ignore Joan'
);

SELECT is(
    COUNT(*)::INT, 2,
    'Should now have 2 ignored'
) FROM ignored;

SELECT is(
    ignored.*,
    ROW('drickles', 'jrivers')::ignored,
    'Should have the proper ignored record'
) FROM ignored WHERE user_nick = 'drickles';

SELECT ok(
    ins_ignore('jrivers', 'gmarx'),
    'Have Joan ignore Groucho'
);

SELECT is(
    COUNT(*)::INT, 3,
    'Should now have 3 ignored'
) FROM ignored;

-- Test del_ignore().
SELECT has_function('del_ignore');
SELECT has_function('del_ignore', ARRAY['text', 'text']);
SELECT function_returns('del_ignore', 'boolean');
SELECT function_lang_is('del_ignore', 'plpgsql');
SELECT volatility_is('del_ignore', 'volatile');
SELECT is_definer('del_ignore');

SELECT ok(
    del_ignore('drickles', 'jrivers'),
    'Have Don unignore Joan'
);

SELECT is(
    COUNT(*)::INT, 2,
    'Should have 2 ignored again'
) FROM ignored;

SELECT ok(
    NOT EXISTS(SELECT TRUE FROM ignored WHERE user_nick = 'drickles'),
    'Don ignoring Joan record should be gone'
);

-- Test del_ignores().
SELECT has_function('del_ignores');
SELECT has_function('del_ignores', ARRAY['text', 'text[]']);
SELECT function_returns('del_ignores', 'boolean');
SELECT function_lang_is('del_ignores', 'plpgsql');
SELECT volatility_is('del_ignores', 'volatile');
SELECT is_definer('del_ignores');

SELECT ok(
    del_ignores('jrivers', 'drickles', 'gmarx'),
    'Have Joan unignore Don and Groucho'
);

SELECT is(
    COUNT(*)::INT, 0,
    'Should onace again have no ignored'
) FROM ignored;

SELECT * FROM finish();
ROLLBACK;
