abstract class IFastAnalyticsService {
  void logEvent({
    required String name,
    Map<String, Object?>? parameters,
  });
}
