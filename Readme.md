# Fake Windows Spotlight

I was incredibly frustrated with Microsoft's insistence on showing me ads on the lock screen, but their image choices are superb. This script is the solution; it will automatically fetch the latest spotlight image and set it as the lock screen, and since Windows sees it as a regular image there are no ads!

**This script depends entirely on https://windows10spotlight.com to fetch the latest images**. I'm not affiliated with that site so no guarantees.

[Thanks to Juan Granados for the `Set-Screen` script](https://gallery.technet.microsoft.com/scriptcenter/Change-Lock-Screen-and-245b63a0)


## Dependencies

[windows10spotlight.com](https://windows10spotlight.com/) must be alive, as mentioned above.

Install [Selenium Powershell](https://github.com/adamdriscoll/selenium-powershell) and whatever dependencies it needs to get the Firefox driver working:

```powershell
Install-Module Selenium
```


## Usage

Run `Set-Latest-Image.ps1` in an elevated Powershell. This should immediately update your lock screen to the latest image listed on [windows10spotlight.com](https://windows10spotlight.com).

To get that Spotlight auto-update magic, run the script daily from the Task Scheduler.


## Reverting the registry changes

If you try to change the lock screen in the Settings after running this script you will see a message like
> Some of these settings are hidden or managed by your organization

To undo these changes and fix the settings run the `Clear-Image.ps1` script.
