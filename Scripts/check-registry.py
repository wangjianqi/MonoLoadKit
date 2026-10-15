#!/usr/bin/env python3
"""Checks style/render registry consistency without relying on Apple SDKs."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
style = (ROOT / 'Sources/MonoLoadKit/MonoLoadingStyle.swift').read_text()
painter = (ROOT / 'Sources/MonoLoadKit/MonoLoadingPainter.swift').read_text()
demo = (ROOT / 'Examples/MonoLoadDemo/MonoLoadDemo/DemoGalleryView.swift').read_text()
case_block = style.split('public enum MonoLoadingStyle:', 1)[1].split('public var id:', 1)[0]
cases = re.findall(r'\bcase\s+(\w+)\s*$', case_block, flags=re.M)
draws = re.findall(r'private func draw(\w+)\(\)', painter)
dispatch = re.findall(r'case \.(\w+): draw(\w+)\(\)', painter)
assert len(cases) == 44, f'Expected 44 style declarations, found {len(cases)}'
assert len(set(cases)) == 44
assert len(draws) == 44 and len(set(draws)) == 44
assert len(dispatch) == 44
for case, func in dispatch:
    assert case in cases, f'Missing public enum style {case}'
    assert func == case[0].upper() + case[1:], f'Unexpected mapping: {case} -> {func}'
    assert func in draws, f'Missing draw function for {case}'
assert cases[28] == 'yinYang' and cases[30] == 'threeBladeFan', 'Original style IDs changed'
assert cases[32] == 'liquidYinYang' and cases[33] == 'silkThreeBlade', 'Enhanced styles are missing'
assert (ROOT / 'Brand/MonoLoadMark.svg').exists()
assert (ROOT / 'Examples/MonoLoadDemo/MonoLoadDemo/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png').exists()
import json, struct
asset_root = ROOT / 'Examples/MonoLoadDemo/MonoLoadDemo/Assets.xcassets'
icon = json.loads((asset_root/'AppIcon.appiconset/Contents.json').read_text())
assert icon['images'][0]['filename'] == 'AppIcon-1024.png'
icon_bytes = (asset_root/'AppIcon.appiconset/AppIcon-1024.png').read_bytes()
assert icon_bytes[:8] == b'\x89PNG\r\n\x1a\n', 'Invalid App Icon PNG'
assert struct.unpack('>II', icon_bytes[16:24]) == (1024, 1024), 'App Icon must be 1024px'
brand = json.loads((asset_root/'BrandMark.imageset/Contents.json').read_text())
for info in brand['images']:
    assert (asset_root/'BrandMark.imageset'/info['filename']).exists()
assert any(info.get('appearances') for info in brand['images']), 'Missing Dark Mode brand asset'
project = (ROOT/'Examples/MonoLoadDemo/MonoLoadDemo.xcodeproj/project.pbxproj').read_text()
assert 'ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon' in project
assert 'Assets.xcassets in Resources' in project
assert 'Image("BrandMark")' in demo, 'Demo brand icon not wired'
assert 'TimelineView' in demo and 'MonoLoadingGlyph' in demo, 'Missing shared gallery timeline'
assert not (ROOT / '.github/workflows').exists(), 'Unexpected GitHub Actions configuration'
print('Registry OK: 44 styles, 44 painters, 44 dispatch mappings; demo timeline and brand present')
