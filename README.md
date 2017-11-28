# sagecrm-cookbook

Cookbook to install Sage CRM Enbu Webservices

## Supported Platforms

Windows

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sagecrmenbuwebservices']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### sagecrmenbuwebservices::default

Include `sagecrmenbuwebservices` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[sagecrmenbuwebservices::default]"
  ]
}
```

## License and Authors

Author:: Taliesin Sisson (<taliesins@yahoo.com>)
