From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v5 3/3] tpm: add securityfs support for TPM 2.0 firmware
 event log
Date: Sat, 26 Nov 2016 14:59:13 +0200
Message-ID: <20161126125913.kavkmocx7ixzs3tp@intel.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
 <1479922057-8752-4-git-send-email-nayna@linux.vnet.ibm.com>
 <20161124211057.xynmfteky5r7uc27@intel.com>
 <20161125194317.GG16504@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161125194317.GG16504@obsidianresearch.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Nov 25, 2016 at 12:43:17PM -0700, Jason Gunthorpe wrote:
> On Thu, Nov 24, 2016 at 11:10:57PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 23, 2016 at 12:27:37PM -0500, Nayna Jain wrote:
> > > Unlike the device driver support for TPM 1.2, the TPM 2.0 does
> > > not support the securityfs pseudo files for displaying the
> > > firmware event log.
> > > 
> > > This patch enables support for providing the TPM 2.0 event log in
> > > binary form. TPM 2.0 event log supports a crypto agile format that
> > > records multiple digests, which is different from TPM 1.2. This
> > > patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
> > > event log parser which understand the TPM 2.0 crypto agile format.
> > > 
> > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > 
> > I don't want to say much about this before I've tested it. I wonder
> > what cheap hardware I could use to test this. Any advice is on this
> > from anyone is much appreciated.
> 
> If you found a small ARM system with TPM you could customize the uboot
> to build an event log and pass it in via DT.
> 
> Not sure how much work that would be, does uboot have tpm code
> already?

I have BeagleBoard Rev C (omap3530 arm board) and it has GPIOs but at
the moment I do not possess a spare dTPM module. I'll ask my employer
for one. It's quite old (2009), which is a good thing because of range
of support I would presume...

If I get the spare dTPM I can do I2C/SPI through GPIOs as long as I find
a way to inject stuff to DT. Hmm.. that said I've never done this
before. I guess you can ask I2C/SPI driver somehow to use GPIOs?

> Jason

/Jarkko
