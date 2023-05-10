import 'package:hd_wallet_flutter/model/error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_provider.freezed.dart';

final nftProvider = StateNotifierProvider<_Provider, NftState>((ref) {
  return _Provider();
});

class _Provider extends StateNotifier<NftState> {
  _Provider() : super(const NftState());

  Future<AppError?> init() async {
    try {
      state = state.copyWith(isLoading: true);

      return null;
    } catch (e) {
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<AppError?> refresh() async {
    try {
      return null;
    } catch (e) {
      return AppError.defaultError();
    }
  }
}

@freezed
class NftState with _$NftState {
  const factory NftState({
    @Default(false) bool isLoading,
  }) = _NftState;
}
