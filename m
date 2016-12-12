From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v3 1/3] tpm_crb: map locality registers
Date: Mon, 12 Dec 2016 19:46:15 +0200
Message-ID: <20161212174615.mhk44plbj5wg4zzs@intel.com>
References: <20161207115001.18332-1-jarkko.sakkinen@linux.intel.com>
 <20161207115001.18332-2-jarkko.sakkinen@linux.intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B5433A4BD@hasmsx108.ger.corp.intel.com>
 <20161212152001.53ewps3jczs4jdld@intel.com>
 <5B8DA87D05A7694D9FA63FD143655C1B5433B524@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B5433B524@hasmsx108.ger.corp.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, open list <linux-kernel@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Dec 12, 2016 at 03:28:01PM +0000, Winkler, Tomas wrote:
> > 
> > I've tested is completley disjoint from the region pointed by the ACPI device
> > tree (SSDT in PTT's case).
> > 
> > Here's example device from my x250:
> > 
> > Device (TPM)
> > {
> > Name (_HID, "MSFT0101" /* TPM 2.0 Security Device */)  // _HID: Hardware ID
> > Name (_STR, Unicode ("TPM 2.0 Device"))  // _STR: Description String Name
> > (CRS, ResourceTemplate () { Memory32Fixed (ReadOnly,
> >     0x00000000,         // Address Base
> >     0x00001000,         // Address Length
> >     _Y00)
> 
> 
> I'm not sure what is that?
> 
> > Memory32Fixed (ReadOnly,
> >     0xFED70000,         // Address Base
> >     0x00001000,         // Address Length
> >     )
> 
> But 0xFED70000 should point to CCA 

When I implemented originally the driver I followed the MS specification
and used the value from TPM2 ACPI table. 

The driver ioremaps 00000000CCDFF000, not the address from SSDT.

> Tomas
> Thanks

/Jarkko
