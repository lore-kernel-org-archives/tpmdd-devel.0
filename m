From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm, tpm_crb: remove redundant
 CRB_FL_CRB_START flag
Date: Thu, 20 Oct 2016 17:00:11 +0300
Message-ID: <20161020140011.s5mu3atjjwnwqda4@intel.com>
References: <20161017204224.27163-1-jarkko.sakkinen@linux.intel.com>
 <20161017225113.qnghq5vroxlmsurc@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542FF8FC@hasmsx108.ger.corp.intel.com>
 <20161019160928.n5fswy25t2ppdh73@intel.com>
 <20161020135906.ah4rjympz3wq6g3t@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161020135906.ah4rjympz3wq6g3t@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Oct 20, 2016 at 04:59:06PM +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 19, 2016 at 07:09:28PM +0300, Jarkko Sakkinen wrote:
> > On Wed, Oct 19, 2016 at 10:28:29AM +0000, Winkler, Tomas wrote:
> > > 
> > > 
> > > > 
> > > > On Mon, Oct 17, 2016 at 11:42:24PM +0300, Jarkko Sakkinen wrote:
> > > > > Because all the existing hardware have HID MSFT0101 we end up always
> > > > > setting CRB_FL_CRB_START flag as a workaround for 4th Gen Core CPUs.
> > > > > Even if ACPI start is used, the driver will always issue also CRB start.
> > > 
> > > Do you have some more historical data about this fix, I was wondering
> > > about this quirk before, when restructuring the start method parsing.
> > > The description is ' in practice seems to require both'  sounds not
> > > certain about the root cause of this.
> > 
> > I have a 4th Gen Core NUC where I experienced this issue. It reported
> > requiring only ACPI start but actually required ACPI + CRB start. The
> > comment could have been better.
> 
> With the latest master branch if I remove the workaround:
> 
> [  395.161155] tpm_crb: module verification failed: signature and/or required key missing - tainting kernel
> [  480.087136] tpm tpm0: A TPM error (323) occurred continue selftest
> [  480.087141] tpm tpm0: TPM self test failed
> 
> jsakkine at jsakkine-tpm1 in ~/devel/linux-tpmdd (master●●) 
> $ git --no-pager diff
> diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
> index 65040d7..5b186e0 100644
> --- a/drivers/char/tpm/tpm_crb.c
> +++ b/drivers/char/tpm/tpm_crb.c
> @@ -407,14 +407,6 @@ static int crb_acpi_add(struct acpi_device *device)
>  	if (!priv)
>  		return -ENOMEM;
>  
> -	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
> -	 * report only ACPI start but in practice seems to require both
> -	 * ACPI start and CRB start.
> -	 */
> -	if (sm == ACPI_TPM2_COMMAND_BUFFER || sm == ACPI_TPM2_MEMORY_MAPPED ||
> -	    !strcmp(acpi_device_hid(device), "MSFT0101"))
> -		priv->flags |= CRB_FL_CRB_START;
> -
>  	if (sm == ACPI_TPM2_START_METHOD ||
>  	    sm == ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD)
>  		priv->flags |= CRB_FL_ACPI_START;
> 
> jsakkine at jsakkine-tpm1 in ~/devel/linux-tpmdd (master●●) 
> $ sudo dmidecode -t bios -q
> BIOS Information
> 	Vendor: Intel Corp.
> 	Version: WYLPT10H.86A.0033.2014.1201.0940
> 	Release Date: 12/01/2014
> 	Address: 0xF0000
> 	Runtime Size: 64 kB
> 	ROM Size: 6656 kB
> 	Characteristics:
> 		PCI is supported
> 		BIOS is upgradeable
> 		BIOS shadowing is allowed
> 		Boot from CD is supported
> 		Selectable boot is supported
> 		BIOS ROM is socketed
> 		EDD is supported
> 		5.25"/1.2 MB floppy services are supported (int 13h)
> 		3.5"/720 kB floppy services are supported (int 13h)
> 		3.5"/2.88 MB floppy services are supported (int 13h)
> 		Print screen service is supported (int 5h)
> 		Serial services are supported (int 14h)
> 		Printer services are supported (int 17h)
> 		ACPI is supported
> 		USB legacy is supported
> 		BIOS boot specification is supported
> 		Targeted content distribution is supported
> 		UEFI is supported
> 	BIOS Revision: 4.6
> 
> BIOS Language Information
> 	Language Description Format: Long
> 	Installable Languages: 1
> 		en|US|iso8859-1
> 	Currently Installed Language: en|US|iso8859-1
> 
> jsakkine at jsakkine-tpm1 in ~/tmp (master) 
> $ cat ~/tmp/tpm2.dsl 
> /*
>  * Intel ACPI Component Architecture
>  * AML Disassembler version 20140214-64 [Mar 29 2014]
>  * Copyright (c) 2000 - 2014 Intel Corporation
>  * 
>  * Disassembly of tpm2.dat, Wed Jun  1 16:26:49 2016
>  *
>  * ACPI Data Table [TPM2]
>  *
>  * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
>  */
> 
> [000h 0000   4]                    Signature : "TPM2"    [Trusted Platform Module hardware interface table]
> [004h 0004   4]                 Table Length : 00000034
> [008h 0008   1]                     Revision : 03
> [009h 0009   1]                     Checksum : 31
> [00Ah 0010   6]                       Oem ID : "INTEL "
> [010h 0016   8]                 Oem Table ID : "D34010WY"
> [018h 0024   4]                 Oem Revision : 00000021
> [01Ch 0028   4]              Asl Compiler ID : ""
> [020h 0032   4]        Asl Compiler Revision : 00000000
> 
> [024h 0036   4]                        Flags : 00000000
> [028h 0040   8]              Control Address : 00000000DBFFF000
> [030h 0048   4]                 Start Method : 00000002
> 
> Raw Table Data: Length 52 (0x34)
> 
>   0000: 54 50 4D 32 34 00 00 00 03 31 49 4E 54 45 4C 20  TPM24....1INTEL 
>   0010: 44 33 34 30 31 30 57 59 21 00 00 00 00 00 00 00  D34010WY!.......
>   0020: 00 00 00 00 00 00 00 00 00 F0 FF DB 00 00 00 00  ................
>   0030: 02 00 00 00                                      ....
> 
> Obviously I'm going to keep the work around because I don't want to risk
> breaking machines in the field. Because as a side effect for any machine
> the driver always invokes CRB start I will definitely want to simplify
> the state of the driver.

Oops. I forgot to mension the device: D34010WYK

http://www.intel.com/content/www/us/en/nuc/nuc-kit-d34010wyk-board-d34010wyb.html

/Jarkko
