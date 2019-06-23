class EpayserviceOauthData {
  final String tokenAccess;
  final String tokenRefresh;
  final int timestampCreatedAt;
  final int timestampExpiresIn;

  EpayserviceOauthData({
    this.tokenAccess = "",
    this.tokenRefresh = "",
    this.timestampCreatedAt = -1,
    this.timestampExpiresIn = -1,
  });

  bool isTokenValid() {
    if (tokenAccess != null && timestampCreatedAt != -1 && timestampExpiresIn != -1) {
      var now = new DateTime.now().toUtc().millisecondsSinceEpoch / 1000;
      return (this.timestampCreatedAt + this.timestampExpiresIn) > now;
    }
    return false;
  }
}
