"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.revokeAutomationToken = exports.listAutomationTokens = exports.generateAutomationToken = exports.transactionIngest = void 0;
var transactionIngest_1 = require("./ingest/transactionIngest");
Object.defineProperty(exports, "transactionIngest", { enumerable: true, get: function () { return transactionIngest_1.transactionIngest; } });
var tokens_1 = require("./automation/tokens");
Object.defineProperty(exports, "generateAutomationToken", { enumerable: true, get: function () { return tokens_1.generateAutomationToken; } });
Object.defineProperty(exports, "listAutomationTokens", { enumerable: true, get: function () { return tokens_1.listAutomationTokens; } });
Object.defineProperty(exports, "revokeAutomationToken", { enumerable: true, get: function () { return tokens_1.revokeAutomationToken; } });
//# sourceMappingURL=index.js.map