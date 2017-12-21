From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] tpm: Fix the driver cleanup code
Date: Thu, 21 Dec 2017 15:30:49 -0700
Message-ID: <20171221223049.GJ20015@ziepe.ca>
References: <1513887422-123222-1-git-send-email-azhar.shaikh@intel.com>
 <20171221202652.GH20015@ziepe.ca>
 <5FFFAD06ADE1CA4381B3F0F7C6AF5828989144@ORSMSX109.amr.corp.intel.com>
 <20171221203853.GI20015@ziepe.ca>
 <5FFFAD06ADE1CA4381B3F0F7C6AF582898918B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5FFFAD06ADE1CA4381B3F0F7C6AF582898918B@ORSMSX109.amr.corp.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Shaikh, Azhar" <azhar.shaikh@intel.com>
Cc: "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>, "javierm@redhat.com" <javierm@redhat.com>, "peterhuewe@gmx.de" <peterhuewe@gmx.de>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Dec 21, 2017 at 09:54:26PM +0000, Shaikh, Azhar wrote:

> Yes, I checked this part. What I was referring to is any other
> callback function similar to clk_enable if gets added in future and
> then needs to Access ops even after it is set to NULL...

You can't call callback functions after tpm_unregister_chip, it isn't
allowed.

This is a special case where we know the specific implementation of
this specific callback is OK.

> But yes I get your point now.
> 
> So do you mean something like this?

Yes

Jason
