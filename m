From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [RFC] tpm2-space: add handling for global session
 exhaustion
Date: Thu, 16 Feb 2017 22:33:04 +0200
Message-ID: <20170216203304.wrbpfd4mrmyh6vct@intel.com>
References: <201702101003.v1AA3plF029882@wind.enjellic.com>
 <1486745163.2502.26.camel@HansenPartnership.com>
 <OFA049276F.2B32440E-ON852580C3.00742287-852580C3.00748E6B@notes.na.collabserv.com>
 <20170214143829.GA28175@wind.enjellic.com>
 <71dc0e80-6678-a124-9184-1f93c8532d09@linux.vnet.ibm.com>
 <20170216200642.GA20942@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170216200642.GA20942@wind.enjellic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dr. Greg Wettstein" <greg@enjellic.com>
Cc: Ken Goldman <kgold@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Feb 16, 2017 at 02:06:42PM -0600, Dr. Greg Wettstein wrote:
> Just as an aside, has anyone given any thought about TPM2 resource
> management in things like TXT/tboot environments?  The current tboot
> code makes a rather naive assumption that it can take a handle slot to
> protect its platform verification secret.  Doing resource management
> correctly will require addressing extra-OS environments such as this
> which may have TPM2 state requirement issues.

The current implementation handles stuff created from regular /dev/tpm0
so I do not think this would be an issue. You can only access objects
from a TPM space that are created within that space.

/Jarkko
