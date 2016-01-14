From: "Peter Huewe" <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: TPM emulator driver status
Date: Thu, 14 Jan 2016 20:28:14 +0100
Message-ID: <trinity-bc340f40-4d00-4382-afb2-83639b925c0d-1452799694114@3capp-gmx-bs69>
References: <201601131436.u0DEaIdD015610@d03av02.boulder.ibm.com>
	<11083.1452692382@warthog.procyon.org.uk>
	<25224.1452779110@warthog.procyon.org.uk>,
	<201601141458.u0EEwsMi006753@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201601141458.u0EEwsMi006753-4ZtxiNBBw+3ImUpY6SP3GEEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

> Gesendet: Donnerstag, 14. Januar 2016 um 06:58 Uhr
> Von: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> An: "David Howells" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "Jarkko Sakkinen" <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Peter Huewe" <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> Betreff: Re: [tpmdd-devel] TPM emulator driver status
> David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote on 01/14/2016 08:45:10 AM:
> 
> 
> > Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > > I wrote a driver for support of (v)TPM for containers. It has ioctl's for
> > > creating and deleting of pairs of devices where one device is usedby clients
> > > and the other end is used by a TPM emulator to listen for
> > commands. The client
> > > device can be 'moved' in the container, meaning a device node with the same
> > > major/minor numbers is created inside a container. Any number of such device
> > > pairs can be create. Does this driver sound like it would provide more
> > > functionality than yours and would it address your use case as well?
> >
> > Maybe.  Is it accessible through the /dev/tpm<N> just like a h/w tpm?  And can
> > it be accessed by in-kernel services that use a tpm?
> 
> Yes to all of the questions.
> 
> The primary target is integration with namespaced IMA and making vTPMs available to each namespaced IMA. However, having the vTPM hooked up to IMA is an extra ioctl that has to be issued at the right moment (essentially before clone()) and is not necessary except for container use-cases. So let me explain how the basic part works.
> 
> Using an ioctl, a new device pair is spawned. The core TPM device driver creates /dev/vtpmcX (with X = 0...), which is just another name for /dev/tpm0. I gave it a different name to be able to distinguish the potentially many drivers from h/w tpm /dev/tpmZ (Z = 0...). Also a backend is created by that driver, with a device called /dev/vtpmsY (Y = 0...) . One places a software TPM emulator on this one and have it listen for commands that are sent into /dev/vtpmcX. If there's no software TPM listening on that device, all commands sent to the backend will receive a -EIO.  So we have this connected device pair /dev/vtpmsY and /dev/vtpmcX, a server and a client side. Another ioctl can delete the device pair unless the backend is busy.
> 
> The above is added by a first series of patches. I can post them today. Subsequent patches would add support for hooking the device pair to IMA namespace...
> 
> So there's no device pair unless someone was to issue the ioctl. Then kernel services would be able to find the device using tpm_chip_find_get(int chip_num) and call the normal APIs to send TPM command, though shouldn't do that before the swtpm has been started to listen on the server side, otherwise they will get -EIO's.
> 
> There's a function call that could probably also create such a device pair during kernel startup or maybe conditionally if no hardware device is available. Preferably we would leave this up to user space to handle this via the ioctl.
> 
> A TPM device that I have been using for this setup is here :
> 
> https://github.com/stefanberger/swtpm
> 
> swtpm chardev --tpmstate dir=<dir> -c /dev/vtpms1 [other options] can be used to start a TPM emulator listening for commands on /dev/vtpmsY. Since the TPM emulator behave just like a h/w TPM, one still needs to simulate the BIOS initialization of the TPM using the tool swtpm_bios run on /dev/vtpmcX.
> 


Hmm, interesting.

I like David's driver since it is super simple to use, and works with the old Strasser's TPM Emulator for 1.2 and with the Microsoft TPM Simulator for 2.0.

Have you tested one or the other with your approach?

I'm not 100% sure about the different name for the tpm emulation, as quite some software relies on the /dev/tpmZ naming - e.g. for testing it would be good to not be able to distinguish them.
So I have the exact same runs on machines with a emulated tpm and with a real hw one.
BUT on the other hand I think it's good to distinguish both (somehow, maybe a sysfs attribute?). 


Honestly I'm lacking a bit behind on the vTPM stuff.
Would this work on a regular x86 machine?


Thanks,
Peter






------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
