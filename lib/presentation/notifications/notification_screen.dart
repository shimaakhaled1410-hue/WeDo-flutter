import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/theme/app_color_scheme.dart';
import 'package:wedo_flutter/domain/entities/notification_entity.dart';
import 'package:wedo_flutter/presentation/manager/notifications/notification_cubit.dart';
import 'package:wedo_flutter/presentation/manager/notifications/notification_state.dart';
import 'widgets/notification_card.dart';
import 'widgets/notification_empty_view.dart';
import 'widgets/notification_error_view.dart';
import 'widgets/notification_header.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
  }

  Future<void> _onRefresh() async {
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              int unreadCount = 0;
              if (state is NotificationLoaded) {
                unreadCount = state.notifications
                    .where((n) => !n.isRead)
                    .length;
              }
              return NotificationHeader(
                unreadCount: unreadCount,
                onBackTap: () => context.pop(),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  );
                }

                if (state is NotificationError) {
                  return NotificationErrorView(
                    message: state.message,
                    onRetry: _onRefresh,
                  );
                }

                if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return NotificationEmptyView(onRefresh: _onRefresh);
                  }

                  return RefreshIndicator(
                    color: colors.primary,
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.notifications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = state.notifications[index];
                        return NotificationCard(
                          item: item,
                          onTap: () {
                            if (!item.isRead) {
                              context.read<NotificationCubit>().markAsRead(
                                item.id,
                              );
                            }

                            final project = item.toProjectEntity();
                            if (project != null) {
                              context.push(
                                AppRoutes.projectDetails,
                                extra: project,
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
