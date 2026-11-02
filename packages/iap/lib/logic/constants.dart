/// Default store key names.
const kFastInAppPurchasesStoreName = 'fastInAppPurchases';

/// The time the store job waits for the store before letting the app start
/// without it. It must stay under the job runner timeout (`kFastJobTimeout`).
const kFastIapStoreJobTimeout = Duration(seconds: 20);
