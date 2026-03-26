import { runTests } from './common.mjs';

const TIERS = [
    'out/main/lua.html',
    'out/main/lua-atmos.html',
    'out/main/atmos.html',
];

runTests(TIERS);
