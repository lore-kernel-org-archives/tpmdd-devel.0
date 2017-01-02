From: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Subject: Re: TPM 2.0 device driver blocking open
Date: Mon, 2 Jan 2017 15:15:00 +0000
Message-ID: <9F48E1A823B03B4790B7E6E69430724DC7C1378B@exch2010c.sit.fraunhofer.de>
References: <o45vtc$ur$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o45vtc$ur$1@blaine.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Yes it is expected and was true for TPM 1.2 as well.

O_NOBLOCK only refers to the "blockiness" of read() and write() operations, not open()s.

I would highly discourage using a patch that does not block open()s.
Reason being: It will inherently become racy, when 3 processes want to use 2 transient objects inside the TPM concurrently, since the TPM only has 3 slots total => deadlock.

That's why current TSS 2.0 and TSS 1.2 assumed a resource-manager in UserSpace as signle owner of /dev/tpm0 (enforced by single-open-/dev/tpm0).
Only alternative would be a RM inside the Kernel.

Multi-Open-/dev/tpm can be a local hack, but please never distribute, merge or advocate it.

Cheers,
Andreas

________________________________________
From: Ken Goldman [kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org]
Sent: Friday, December 30, 2016 16:53
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Subject: [tpmdd-devel] TPM 2.0 device driver blocking open

It appears that an open() to the TPM doesn't block if another process
has /dev/tpm0 open.  It returns -1, an error.

Questions:

Is this expected behavior?
Was this also true for 1.2?
Is there any way to change it.  I didn't set O_NOBLOCK.  Is there
perhaps an ioctl()?
Is this something that should be added?


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
