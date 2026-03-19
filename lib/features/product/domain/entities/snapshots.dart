import 'package:equatable/equatable.dart';

class DropMetadata extends Equatable {
  const DropMetadata({this.saleEndTime, required this.dropLabel});

  final DateTime? saleEndTime;
  final String dropLabel;

  bool get hasCountdown => saleEndTime != null;

  @override
  List<Object?> get props => <Object?>[saleEndTime, dropLabel];
}

class InventorySnapshot extends Equatable {
  const InventorySnapshot({
    required this.availableCount,
    required this.totalCount,
    required this.isLowStock,
  });

  final int availableCount;
  final int totalCount;
  final bool isLowStock;

  @override
  List<Object?> get props => <Object?>[availableCount, totalCount, isLowStock];
}

class ReactionSnapshot extends Equatable {
  const ReactionSnapshot({
    required this.reactionCount,
    required this.liveViewerCount,
    required this.hasReacted,
  });

  final int reactionCount;
  final int liveViewerCount;
  final bool hasReacted;

  ReactionSnapshot copyWith({
    int? reactionCount,
    int? liveViewerCount,
    bool? hasReacted,
  }) {
    return ReactionSnapshot(
      reactionCount: reactionCount ?? this.reactionCount,
      liveViewerCount: liveViewerCount ?? this.liveViewerCount,
      hasReacted: hasReacted ?? this.hasReacted,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    reactionCount,
    liveViewerCount,
    hasReacted,
  ];
}
