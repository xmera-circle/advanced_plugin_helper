# Advanced Plugin Helper

Encapsulate presentation logic and Redmine patch management in PORO

![Redmine Plugin Version](https://img.shields.io/badge/Redmine_Plugin-v0.2.0-red) ![Redmine Version](https://img.shields.io/badge/Redmine-v5.0.x-blue) ![Language Support](https://img.shields.io/badge/Languages-en,_de-green) ![Version Stage](https://img.shields.io/badge/Stage-release-important)

The Advanced Plugin Helper plugin is a Redmine plugin for developers. It is helping to keep Rails helper and views light in favour of encapsulating presentation login in plain old ruby classes (PORO) and provides a Patch API to easily register Redmine patches for Redmine 4 or 5.

---

## Usage example

These examples are quite short to give you a first impression. You can find much more information and step by step instructions about how to use the plugin in the [official documentation](https://circle.xmera.de/projects/advanced-plugin-helper/wiki/Wiki).

### Presenter

Move your business logic from your views to presenter classes and integrate the transfered methods into your views like so:

```ruby
<%= show(@my_model).helper_method_for_my_model %>
```

### Redmine Patches

Register your Redmine patches and make sure they will be loaded when the plugin is registered.

```ruby
data = { klass: Issue, patch: MyRedminePlugin::Extensions::IssuePatch, strategy: :include }
AdvancedPluginHelper::Patch.register(data)
```

## Installation

> :warning: **Don't clone the default branch**: For production you need to clone the **_master_** branch explicitly!

```shell
git clone -b master https://github.com/xmera-circle/advanced_plugin_helper
```

You need a running Redmine instance in order to install the plugin. If you need help with the installation, please refer to [Redmine.org](https://redmine.org).

Instructions for the installation of this plugin can be found in the [official documentation](https://circle.xmera.de/projects/advanced-plugin-helper/wiki) on
[xmera Circle » Community Portal](https://circle.xmera.de).

## Changelog

All notable changes to this plugin will be reported in the [changelog](https://circle.xmera.de/projects/advanced-plugin-helper/repository/advanced_plugin_helper/entry/CHANGELOG.md).

## Maintainer

This project is maintained by xmera Solutions GmbH.

## Support

For any question on the usage of this plugin please use the [xmera Circle » Community Portal](https://circle.xmera.de). If you found a problem with the software, please create an issue on xmera Circle or GitHub. 

If you are a xmera Solutions customer you may alternatively forward your issue to the xmera Service Customer Portal.

## Security

xmera Solutions takes the security of our software products seriously. 

If you believe you have found a security vulnerability in any xmera Solutions-owned repository, please report it to us as described in the [SECURITY.md](/SECURITY.md).

## Code of Conduct

We pledge to act and interact in ways that contribute to an open, welcoming, diverse, inclusive, and healthy community. 

Please read our [Code of Conduct](https://circle.xmera.de/projects/contributors-guide/wiki/Code-of-conduct) to make sure that you agree to follow it.

## Contributing

Your contributions are highly appreciated. There are plenty ways [how you can help](https://circle.xmera.de/projects/contributors-guide/wiki).

In case you like to improve the code, please create a pull request on GitHub. Bigger changes need to be discussed on [xmera Circle » Community Portal](https://circle.xmera.de) first.

## License

Copyright (C) 2022-2023 Liane Hampe (<liaham@xmera.de>), xmera Solutions GmbH.

This plugin program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
[GNU General Public License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html) for more details.
