import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'menus.dart' show RequestCardMenu;
import 'texts.dart' show MethodBox;

class SidebarRequestCard extends StatefulWidget {
  const SidebarRequestCard({
    super.key,
    required this.id,
    required this.method,
    this.name,
    this.url,
    this.activeRequestId,
    this.editRequestId,
    this.onTap,
    this.onDoubleTap,
    this.onChangedNameEditor,
    this.onTapOutsideNameEditor,
    this.onMenuSelected,
  });

  final String id;
  final String? name;
  final String? url;
  final HTTPVerb method;
  final String? activeRequestId;
  final String? editRequestId;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final Function(String)? onChangedNameEditor;
  final Function()? onTapOutsideNameEditor;
  final Function(RequestItemMenuOption)? onMenuSelected;

  @override
  State<SidebarRequestCard> createState() => _SidebarRequestCardState();
}

class _SidebarRequestCardState extends State<SidebarRequestCard> {
  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.surface;
    final Color colorVariant =
        Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);
    final Color surfaceTint = Theme.of(context).colorScheme.primary;
    bool isActiveId = widget.activeRequestId == widget.id;
    bool inEditMode = widget.editRequestId == widget.id;
     return Scrollbar(
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topRight, // Aligns the sidebar to the top right corner
    child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: kBorderRadius12,
            ),
            elevation: isActiveId ? 1 : 0,
            surfaceTintColor: isActiveId ? surfaceTint : null,
            color: isActiveId
                ? Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? colorVariant
                    : color
                : color,
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: kBorderRadius12,
              hoverColor: colorVariant,
              focusColor: colorVariant.withOpacity(0.5),
              onTap: inEditMode ? null : widget.onTap,
              onDoubleTap: inEditMode ? null : widget.onDoubleTap,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: isActiveId ? 0 : 20,
                  top: 5,
                  bottom: 5,
                ),
                child: SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      MethodBox(method: widget.method),
                      kHSpacer5,
                      Expanded(
                        child: inEditMode
                            ? TextFormField(
                                key: Key("${widget.id}-name"),
                                initialValue: widget.name,
                                autofocus: true,
                                style: Theme.of(context).textTheme.bodyMedium,
                                onTapOutside: (_) {
                                  widget.onTapOutsideNameEditor?.call();
                                  FocusScope.of(context).unfocus();
                                },
                                onChanged: widget.onChangedNameEditor,
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              )
                            : Text(
                                (widget.name != null &&
                                        widget.name!.trim().isNotEmpty)
                                    ? widget.name!
                                    : getRequestTitleFromUrl(widget.url),
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                      ),
                      Visibility(
                        visible: isActiveId && !inEditMode,
                        child: RequestCardMenu(
                          onSelected: widget.onMenuSelected,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RequestDetailsCard extends StatefulWidget {
  const RequestDetailsCard({super.key, this.child});

  final Widget? child;
  @override
  State<RequestDetailsCard> createState() => _RequestDetailsCardState();
}

class _RequestDetailsCardState extends State<RequestDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: kBorderRadius12,
      ),
      elevation: 0,
      child: widget.child,
    );
  }
}
