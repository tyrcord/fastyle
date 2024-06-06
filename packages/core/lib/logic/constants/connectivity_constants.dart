const kFastConnectivityCheckThrottleDuration = Duration(milliseconds: 350);
const kFastConnectivityCheckInterval = Duration(seconds: 60);
const kFastConnectivityCheckTimeout = Duration(seconds: 10);

const kFastConnectivityCheckAddresses = [
  '8.8.8.8', // Google DNS
  '1.1.1.1', // Cloudflare DNS
  'google.com', // Google
  'cloudflare.com', // Cloudflare
];

const kFastConnectivityCheckPorts = [
  53, // DNS port for Google DNS
  53, // DNS port for Cloudflare DNS
  80, // HTTP port for Google
  80, // HTTP port for Cloudflare
];
