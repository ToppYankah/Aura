import 'dart:developer';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:iconsax/iconsax.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  WebViewScreen({super.key, required this.url})
      : assert(CommonUtils.urlRegex.hasMatch(url));

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _loading = true;
  String? _failingUrl = "";
  InAppWebViewController? _webViewController;

  void handleWevViewCreated(InAppWebViewController controller) async {
    log("Web view created!! $controller");
    setState(() => _webViewController = controller);

    if (_failingUrl != null || _failingUrl!.isNotEmpty) {
      await controller.loadUrl(
          urlRequest: URLRequest(url: Uri.parse(widget.url)));
    }
  }

  void _handleLoadFailure(
      InAppWebViewController controller, Uri? uri, int id, String error) {
    log("Error URL: ${uri?.origin}");
    setState(() => _failingUrl = uri?.origin);
  }

  void _handleLoadFinish(InAppWebViewController controller, Uri? uri) {
    setState(() => _loading = false);
  }

  void _handleLoadStart(InAppWebViewController controller, Uri? uri) {
    setState(() => _loading = true);
  }

  Future<bool> _handleWillPop() async {
    if (_webViewController != null) {
      if (await _webViewController!.canGoBack()) {
        await _webViewController?.goBack();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      onWillPop: _handleWillPop,
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            SafeArea(
              bottom: false,
              child: AppHeader(
                title: "Aura Browser",
                trailing: AppIconButton(
                  radius: 19,
                  disabled: _loading,
                  icon: Iconsax.refresh,
                  background: theme.cardBackground,
                  onTap: _webViewController?.reload,
                  iconColor: isDark ? AppColors.secondary : AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: InAppWebView(
                onLoadStop: _handleLoadFinish,
                onLoadStart: _handleLoadStart,
                onLoadError: _handleLoadFailure,
                onWebViewCreated: handleWevViewCreated,
                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              ),
            ),
          ],
        );
      },
    );
  }
}
