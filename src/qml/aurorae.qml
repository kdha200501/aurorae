/*
    SPDX-FileCopyrightText: 2012 Martin Gräßlin <mgraesslin@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick
import org.kde.kwin.decoration
import org.kde.ksvg 1.0 as KSvg

Decoration {
    id: root
    property bool animate: false
    property alias decorationMask: maskItem.mask
    property alias supportsMask: backgroundSvg.supportsMask
    Component.onCompleted: {
        borders.left   = Qt.binding(function() { return Math.max(0, auroraeTheme.borderLeft - 1);});
        borders.right  = Qt.binding(function() { return Math.max(0, auroraeTheme.borderRight + decoration.client.maximized ? 3 : 0);});
        borders.top    = Qt.binding(function() { return Math.max(0, auroraeTheme.borderTop - 7);});
        borders.bottom = Qt.binding(function() { return Math.max(0, auroraeTheme.borderBottom);});
        maximizedBorders.left   = Qt.binding(function() { return Math.max(0, auroraeTheme.borderLeftMaximized - 1);});
        maximizedBorders.right  = Qt.binding(function() { return Math.max(0, auroraeTheme.borderRightMaximized + decoration.client.maximized ? 3 : 0);});
        maximizedBorders.bottom = Qt.binding(function() { return Math.max(0, auroraeTheme.borderBottomMaximized);});
        maximizedBorders.top    = Qt.binding(function() { return Math.max(0, auroraeTheme.borderTopMaximized - 7);});
        padding.left   = auroraeTheme.paddingLeft;
        padding.right  = auroraeTheme.paddingRight;
        padding.bottom = auroraeTheme.paddingBottom;
        padding.top    = auroraeTheme.paddingTop;
        root.animate = true;
    }
    DecorationOptions {
        id: options
        deco: decoration
    }
    Item {
        id: titleRect
        x: decoration.client.maximized ? maximizedBorders.left : borders.left
        y: decoration.client.maximized ? 0 : root.borders.bottom
        width: decoration.client.width//parent.width - x - (decoration.client.maximized ? maximizedBorders.right : borders.right)
        height: decoration.client.maximized ? maximizedBorders.top : borders.top
        Component.onCompleted: {
            decoration.installTitleItem(titleRect);
        }
    }
    KSvg.FrameSvg {
        property bool supportsInactive: hasElementPrefix("decoration-inactive")
        property bool supportsMask: hasElementPrefix("mask")
        property bool supportsMaximized: hasElementPrefix("decoration-maximized")
        property bool supportsMaximizedInactive: hasElementPrefix("decoration-maximized-inactive")
        property bool supportsInnerBorder: hasElementPrefix("innerborder")
        property bool supportsInnerBorderInactive: hasElementPrefix("innerborder-inactive")
        id: backgroundSvg
        imagePath: auroraeTheme.decorationPath
    }
    KSvg.FrameSvgItem {
        id: decorationActive
        property bool shown: (!decoration.client.maximized || !backgroundSvg.supportsMaximized) && (decoration.client.active || !backgroundSvg.supportsInactive)
        anchors.fill: parent
        imagePath: backgroundSvg.imagePath
        prefix: "decoration"
        opacity: shown ? 1 : 0
        enabledBorders: KSvg.FrameSvg.TopBorder | KSvg.FrameSvg.BottomBorder | KSvg.FrameSvg.LeftBorder | KSvg.FrameSvg.RightBorder
        Behavior on opacity {
            enabled: root.animate
            NumberAnimation {
                duration: auroraeTheme.animationTime
            }
        }
    }
    KSvg.FrameSvgItem {
        id: decorationInactive
        anchors.fill: parent
        imagePath: backgroundSvg.imagePath
        prefix: "decoration-inactive"
        opacity: (!decoration.client.active && backgroundSvg.supportsInactive) ? 1 : 0
        enabledBorders: decoration.client.maximized ? KSvg.FrameSvg.NoBorder : KSvg.FrameSvg.TopBorder | KSvg.FrameSvg.BottomBorder | KSvg.FrameSvg.LeftBorder | KSvg.FrameSvg.RightBorder
        Behavior on opacity {
            enabled: root.animate
            NumberAnimation {
                duration: auroraeTheme.animationTime
            }
        }
    }
    KSvg.FrameSvgItem {
        id: decorationMaximized
        property bool shown: decoration.client.maximized && backgroundSvg.supportsMaximized && (decoration.client.active || !backgroundSvg.supportsMaximizedInactive)
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 0
            rightMargin: 0
            topMargin: 0
        }
        imagePath: backgroundSvg.imagePath
        prefix: "decoration-maximized"
        height: parent.maximizedBorders.top
        opacity: shown ? 1 : 0
        enabledBorders: KSvg.FrameSvg.NoBorder
        Behavior on opacity {
            enabled: root.animate
            NumberAnimation {
                duration: auroraeTheme.animationTime
            }
        }
    }
    KSvg.FrameSvgItem {
        id: decorationMaximizedInactive
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 0
            rightMargin: 0
            topMargin: 0
        }
        imagePath: backgroundSvg.imagePath
        prefix: "decoration-maximized-inactive"
        height: parent.maximizedBorders.top
        opacity: (!decoration.client.active && decoration.client.maximized && backgroundSvg.supportsMaximizedInactive) ? 1 : 0
        enabledBorders: KSvg.FrameSvg.NoBorder
        Behavior on opacity {
            enabled: root.animate
            NumberAnimation {
                duration: auroraeTheme.animationTime
            }
        }
    }
//    AuroraeButtonGroup {
//        id: leftButtonGroup
//        buttons: options.titleButtonsLeft
//        width: childrenRect.width
//        animate: root.animate
//        anchors {
//            left: root.left
//            leftMargin: decoration.client.maximized ? auroraeTheme.titleEdgeLeftMaximized : (auroraeTheme.titleEdgeLeft + root.padding.left)
//        }
//    }
//    AuroraeButtonGroup {
//        id: rightButtonGroup
//        buttons: options.titleButtonsRight
//        width: childrenRect.width
//        animate: root.animate
//        anchors {
//            right: root.right
//            rightMargin: decoration.client.maximized ? auroraeTheme.titleEdgeRightMaximized : (auroraeTheme.titleEdgeRight + root.padding.right)
//        }
//    }
//    Text {
//        id: caption
//        text: decoration.client.caption
//        textFormat: Text.PlainText
//        horizontalAlignment: auroraeTheme.horizontalAlignment
//        verticalAlignment: auroraeTheme.verticalAlignment
//        elide: Text.ElideRight
//        height: Math.max(auroraeTheme.titleHeight, auroraeTheme.buttonHeight * auroraeTheme.buttonSizeFactor)
//        color: decoration.client.active ? auroraeTheme.activeTextColor : auroraeTheme.inactiveTextColor
//        font: options.titleFont
//        renderType: Text.NativeRendering
//        anchors {
//            left: leftButtonGroup.right
//            right: rightButtonGroup.left
//            top: root.top
//            topMargin: decoration.client.maximized ? auroraeTheme.titleEdgeTopMaximized : (auroraeTheme.titleEdgeTop + root.padding.top)
//            leftMargin: auroraeTheme.titleBorderLeft
//            rightMargin: auroraeTheme.titleBorderRight
//        }
//        Behavior on color {
//            enabled: root.animate
//            ColorAnimation {
//                duration: auroraeTheme.animationTime
//            }
//        }
//    }
    KSvg.FrameSvgItem {
        id: innerBorder
        anchors {
            fill: parent
            leftMargin: parent.padding.left + parent.borders.left - margins.left
            rightMargin: parent.padding.right + parent.borders.right - margins.right
            topMargin: parent.padding.top + parent.borders.top - margins.top
            bottomMargin: parent.padding.bottom + parent.borders.bottom - margins.bottom
        }
        visible: parent.borders.left > fixedMargins.left
            && parent.borders.right > fixedMargins.right
            && parent.borders.top > fixedMargins.top
            && parent.borders.bottom > fixedMargins.bottom

        imagePath: backgroundSvg.imagePath
        prefix: "innerborder"
        opacity: (decoration.client.active && !decoration.client.maximized && backgroundSvg.supportsInnerBorder) ? 1 : 0
        Behavior on opacity {
            enabled: root.animate
            NumberAnimation {
                duration: auroraeTheme.animationTime
            }
        }
    }

    Rectangle {
        id: leftButtonGroup
        height: childrenRect.height
        width: childrenRect.width + 6
        anchors {
            top: root.top
            left: root.left
            topMargin: 2
            rightMargin: 0
            bottomMargin: 0
            leftMargin: 2
        }
        color: decoration.client.active ? "#CCCCCC" : "#DDDDDD"
        AuroraeButtonGroup {
            id: leftButtonGroupCta
            buttons: options.titleButtonsLeft
            height: childrenRect.height
            width: childrenRect.width
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 1
                rightMargin: 1
                bottomMargin: 1
                leftMargin: 1
            }
            animate: root.animate
        }
    }
    Rectangle {
        id: rightButtonGroup
        height: childrenRect.height
        width: childrenRect.width + 6
        anchors {
            top: root.top
            right: root.right
            topMargin: 2
            rightMargin: 4
            bottomMargin: 0
            leftMargin: 0
        }
        color: decoration.client.active ? "#CCCCCC" : "#DDDDDD"
        AuroraeButtonGroup {
              id: rightButtonGroupCta
              buttons: options.titleButtonsRight
              height: childrenRect.height
              width: childrenRect.width
              anchors {
                  top: parent.top
                  horizontalCenter: parent.horizontalCenter
                  topMargin: 1
                  rightMargin: 1
                  bottomMargin: 1
                  leftMargin: 1
              }
              animate: root.animate
          }
    }
    Rectangle {
        id: caption
        height: 15
        width: captionMetrics.width + 15
        anchors {
            horizontalCenter: parent.horizontalCenter
            //left: leftButtonGroup.right
            //right: rightButtonGroup.left
            top: root.top
            topMargin: auroraeTheme.titleEdgeTop + root.padding.top + 2
            leftMargin: auroraeTheme.titleBorderLeft
            rightMargin: auroraeTheme.titleBorderRight
        }
        color: decoration.client.active ? "#CCCCCC" : "#DDDDDD"
        Text {
            id: captionText
            text: decoration.client.caption
            textFormat: Text.PlainText
            horizontalAlignment: auroraeTheme.horizontalAlignment
            verticalAlignment: auroraeTheme.verticalAlignment
            elide: Text.ElideRight
            color: decoration.client.active ? auroraeTheme.activeTextColor : auroraeTheme.inactiveTextColor
            //font: options.titleFont
            font.pixelSize: 12
            renderType: Text.NativeRendering
            anchors.centerIn: parent
            Behavior on color {
                enabled: root.animate
                ColorAnimation {
                    duration: auroraeTheme.animationTime
                }
            }
        }
        TextMetrics {
            id: captionMetrics
            text: decoration.client.caption
            font: options.titleFont
        }
    }
    KSvg.FrameSvgItem {
        id: innerBorderInactive
        anchors {
            fill: parent
            leftMargin: parent.padding.left + parent.borders.left - margins.left
            rightMargin: parent.padding.right + parent.borders.right - margins.right
            topMargin: parent.padding.top + parent.borders.top - margins.top
            bottomMargin: parent.padding.bottom + parent.borders.bottom - margins.bottom
        }

        visible: parent.borders.left > fixedMargins.left
            && parent.borders.right > fixedMargins.right
            && parent.borders.top > fixedMargins.top
            && parent.borders.bottom > fixedMargins.bottom

        imagePath: backgroundSvg.imagePath
        prefix: "innerborder-inactive"
        opacity: (!decoration.client.active && !decoration.client.maximized && backgroundSvg.supportsInnerBorderInactive) ? 1 : 0
        Behavior on opacity {
            enabled: root.animate
            NumberAnimation {
                duration: auroraeTheme.animationTime
            }
        }
    }
    KSvg.FrameSvgItem {
        id: maskItem
        anchors.fill: parent
        // This makes the mask slightly smaller than the frame. Since the svg will have antialiasing and the mask not,
        // there will be artifacts at the corners, if they go under the svg they're less evident
        anchors.margins: 1
        imagePath: backgroundSvg.imagePath
        opacity: 0
        enabledBorders: KSvg.FrameSvg.TopBorder | KSvg.FrameSvg.BottomBorder | KSvg.FrameSvg.LeftBorder | KSvg.FrameSvg.RightBorder
    }
}
