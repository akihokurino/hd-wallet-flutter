import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:hd_wallet_flutter/ui/component/dialog.dart';
import 'package:hd_wallet_flutter/provider/nft/nft_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NftListPage extends HookConsumerWidget {
  const NftListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nftProvider);
    final action = ref.read(nftProvider.notifier);

    final isMounted = useIsMounted();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.wait([action.init()]).then((err) {
          final errors = err.where((element) => element != null).toList();
          if (errors.isNotEmpty) {
            AppDialog().showErrorAlert(context, errors.first!);
            return;
          }
        });
      });

      return () {};
    }, const []);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text(""),
          centerTitle: true,
        ),
      ),
      body: WidgetHUD(
          builder: (context) => RefreshIndicator(
                child: ListView(
                  children: const [],
                ),
                onRefresh: () async {
                  final mounted = isMounted();

                  final err = await action.refresh();
                  if (err != null) {
                    if (mounted) {
                      AppDialog().showErrorAlert(context, err);
                    }
                    return;
                  }
                },
              ),
          showHUD: state.isLoading),
    );
  }
}
